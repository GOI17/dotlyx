// See the Electron documentation for details on how to use preload scripts:
// https://www.electronjs.org/docs/latest/tutorial/process-model#preload-scripts
import { contextBridge, ipcRenderer } from "electron";

// Define types for better TypeScript support
export interface ScriptResult {
  processId: string;
  code: number;
  stdout: string;
  stderr: string;
  success: boolean;
}

export interface ScriptOutput {
  processId: string;
  type: "stdout" | "stderr";
  data: string;
}

contextBridge.exposeInMainWorld("dotlyx", {
  path: "~/Documents/personal/workspace/dotlyx",
});

contextBridge.exposeInMainWorld("electronAPI", {
  platform: process.platform,

  // Execute bash script file
  executeBashScript: (
    scriptPath: string,
    args?: string[],
  ): Promise<ScriptResult> =>
    ipcRenderer.invoke("execute:bash-script", scriptPath, args),

  // Execute bash command
  executeBashCommand: (command: string): Promise<ScriptResult> =>
    ipcRenderer.invoke("execute:bash-command", command),

  // Kill running process
  killProcess: (
    processId: string,
  ): Promise<{ success: boolean; error?: string }> =>
    ipcRenderer.invoke("kill:process", processId),

  // List running processes
  listProcesses: (): Promise<string[]> => ipcRenderer.invoke("list:processes"),

  // Event listeners for real-time output
  onScriptOutput: (callback: (output: ScriptOutput) => void) => {
    ipcRenderer.on("script:output", (_, output) => callback(output));
  },

  onScriptStarted: (
    callback: (data: { processId: string; command: string }) => void,
  ) => {
    ipcRenderer.on("script:started", (_, data) => callback(data));
  },

  onScriptCompleted: (callback: (result: ScriptResult) => void) => {
    ipcRenderer.on("script:completed", (_, result) => callback(result));
  },

  onScriptError: (
    callback: (data: { processId: string; error: string }) => void,
  ) => {
    ipcRenderer.on("script:error", (_, data) => callback(data));
  },

  // Remove event listeners
  removeAllListeners: (channel: string) => {
    ipcRenderer.removeAllListeners(channel);
  },
});

// TypeScript declarations
declare global {
  interface Window {
    dotlyx: {
      path: string;
    };
    electronAPI: {
      platform: string;
      executeBashScript: (
        scriptPath: string,
        args?: string[],
      ) => Promise<ScriptResult>;
      executeBashCommand: (command: string) => Promise<ScriptResult>;
      killProcess: (
        processId: string,
      ) => Promise<{ success: boolean; error?: string }>;
      listProcesses: () => Promise<string[]>;
      onScriptOutput: (callback: (output: ScriptOutput) => void) => void;
      onScriptStarted: (
        callback: (data: { processId: string; command: string }) => void,
      ) => void;
      onScriptCompleted: (callback: (result: ScriptResult) => void) => void;
      onScriptError: (
        callback: (data: { processId: string; error: string }) => void,
      ) => void;
      removeAllListeners: (channel: string) => void;
    };
  }
}
