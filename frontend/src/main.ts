import { app, BrowserWindow, ipcMain } from "electron";
import path from "node:path";
import os from "node:os";
import fs from "node:fs";
import { ChildProcess, spawn } from "node:child_process";
import started from "electron-squirrel-startup";

// Handle creating/removing shortcuts on Windows when installing/uninstalling.
if (started) {
  app.quit();
}

function getShell(): string {
  if (process.platform === "win32") {
    return process.env.COMSPEC || "cmd.exe";
  }
  return process.env.SHELL || "/bin/bash";
}

function resolvePath(filePath: string): string {
  if (filePath.startsWith("~/")) {
    return path.join(os.homedir(), filePath.slice(2));
  }
  return path.resolve(filePath);
}

function validateScript(scriptPath: string): {
  valid: boolean;
  error?: string;
} {
  const resolvedPath = resolvePath(scriptPath);

  if (!fs.existsSync(resolvedPath)) {
    return { valid: false, error: `File not found: ${resolvedPath}` };
  }

  const stats = fs.statSync(resolvedPath);
  if (!stats.isFile()) {
    return { valid: false, error: `Path is not a file: ${resolvedPath}` };
  }

  // Check if file is executable (Unix-like systems)
  if (process.platform !== "win32") {
    try {
      fs.accessSync(resolvedPath, fs.constants.X_OK);
    } catch (err) {
      return {
        valid: false,
        error: `File is not executable. Run: chmod +x ${resolvedPath}`,
      };
    }
  }

  return { valid: true };
}

const createWindow = () => {
  // Create the browser window.
  const mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, "preload.js"),
    },
  });

  // and load the index.html of the app.
  if (MAIN_WINDOW_VITE_DEV_SERVER_URL) {
    mainWindow.loadURL(MAIN_WINDOW_VITE_DEV_SERVER_URL);
    mainWindow.webContents.openDevTools();
  } else {
    mainWindow.loadFile(
      path.join(__dirname, `../renderer/${MAIN_WINDOW_VITE_NAME}/index.html`),
    );
  }

  const runningProcesses = new Map<string, ChildProcess>();

  ipcMain.handle(
    "execute:bash-script",
    async (event, scriptPath: string, args: string[] = []) => {
      const processId = `process_${Date.now()}`;

      return new Promise((resolve, reject) => {
        const resolvedPath = resolvePath(scriptPath);
        const validation = validateScript(resolvedPath);
        if (!validation.valid) {
          reject(validation.error);
        }

        console.log({ resolvedPath, validation });

        const _process = spawn(getShell(), [resolvedPath, ...args], {
          cwd: path.dirname(scriptPath),
          env: { ...process.env },
          stdio: ["pipe", "pipe", "pipe"],
        });

        runningProcesses.set(processId, _process);

        let stdout = "";
        let stderr = "";

        _process.stdout.on("data", (data) => {
          const output = data?.toString();
          stdout += output;

          mainWindow.webContents.send("script:output", {
            processId,
            type: "stdout",
            data: output,
          });
        });

        _process.stderr.on("data", (data) => {
          const output = data?.toString();
          stderr += output;

          mainWindow.webContents.send("script:output", {
            processId,
            type: "stderr",
            data: output,
          });
        });

        _process.on("close", (code) => {
          runningProcesses.delete(processId);

          mainWindow.webContents.send("script:completed", {
            processId,
            code,
            stdout,
            stderr,
          });

          resolve({
            processId,
            code,
            stdout,
            stderr,
            success: code === 0,
          });
        });

        _process.on("error", (error) => {
          runningProcesses.delete(processId);

          mainWindow.webContents.send("script:error", {
            processId,
            error: error.message,
          });

          reject(error);
        });

        mainWindow.webContents.send("script:started", {
          processId,
          command: `bash ${scriptPath} ${args.join(" ")}`,
        });
      });
    },
  );

  ipcMain.handle("execute:bash-command", async (event, command: string) => {
    const processId = `cmd_${Date.now()}`;

    return new Promise((resolve, reject) => {
      const process = spawn("bash", ["-c", command]);

      runningProcesses.set(processId, process);

      let stdout = "";
      let stderr = "";

      process.stdout.on("data", (data) => {
        const output = data.toString();
        stdout += output;
        mainWindow.webContents.send("script:output", {
          processId,
          type: "stdout",
          data: output,
        });
      });

      process.stderr.on("data", (data) => {
        const output = data.toString();
        stderr += output;
        mainWindow.webContents.send("script:output", {
          processId,
          type: "stderr",
          data: output,
        });
      });

      process.on("close", (code) => {
        runningProcesses.delete(processId);
        resolve({ processId, code, stdout, stderr, success: code === 0 });
      });

      process.on("error", (error) => {
        runningProcesses.delete(processId);
        reject(error);
      });
    });
  });

  ipcMain.handle("kill:process", async (event, processId: string) => {
    const process = runningProcesses.get(processId);
    if (process) {
      process.kill("SIGTERM");
      runningProcesses.delete(processId);
      return { success: true };
    }
    return { success: false, error: "Process not found" };
  });

  ipcMain.handle("list:processes", async () => {
    return Array.from(runningProcesses.keys());
  });
};

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  createWindow();

  app.on("activate", () => {
    // On OS X it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on("window-all-closed", () => {
  if (process.platform !== "darwin") {
    app.quit();
  }
});

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and import them here.
