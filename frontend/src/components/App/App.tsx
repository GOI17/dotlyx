import { Suspense, useCallback, useState } from "react";

export const App = () => {
  const { executeScript, scriptState, output } = useRunScript();

  const handleOnClickRequirementsCheck = () => {
    executeScript<"requirements">(`../requirements`, "requirements");
  };

  const handleOnClickInstallDotlyx = () => {
    executeScript<"install">(`../install`, "install", true);
  };

  return (
    <div>
      <section>
        <header>
          <h1 role="heading" title="Dotlyx welcome banner">
            Welcome to Dotlyx!
          </h1>
        </header>
      </section>
      <section title="Dotlyx available options">
        <button
          onClick={handleOnClickRequirementsCheck}
          title="Dotlyx requirements check. This button will execute a script that checks if all required tools are available in your local."
        >
          Requirements check
        </button>
        <button
          onClick={handleOnClickInstallDotlyx}
          title="Dotlyx init setup. This button will initialize everyting in your local to use dotlyx."
        >
          Install dotlyx
        </button>
      </section>
      <section title="Dotlyx script output">
        <Suspense fallback={<span>Script is loading...</span>}>
          {scriptState === "failed" ? (
            <span>Script execution failed</span>
          ) : null}
          {["started", "in_progress"].includes(scriptState) ? (
            <span>Script is running...</span>
          ) : null}
          {output?.value ? (
            <section title={`Dotlyx ${output.type}`}>
              {output.type === "requirements" ? (
                <RequirementsList value={output.value as string} />
              ) : null}
              {output.type === "install" ? (
                <>{JSON.stringify(output.value)}</>
              ) : null}
            </section>
          ) : null}
        </Suspense>
      </section>
    </div>
  );
};

interface RequirementsListProps<V> {
  value: V;
}

const RequirementsList = <V,>({ value }: RequirementsListProps<V>) => {
  return (
    <ul title="Dotlyx requirements list" style={{ listStyle: "none" }}>
      {JSON.stringify(value)
        .replaceAll("\\n", "</br>")
        .replaceAll('"', "")
        .split("</br>")
        .map((text) => {
          if (text.length === 0) return;
          return (
            <li title={`Dotlyx requirements list item, ${text}`}>{text}</li>
          );
        })}
    </ul>
  );
};

interface BaseCommand {
  <T extends string>(command: string, type: T): void;
  <T extends string>(command: string, type: T, subscribe?: boolean): void;
}

const useRunScript = () => {
  const [scriptState, setScriptState] = useState<
    "started" | "in_progress" | "completed" | "failed"
  >();
  const [output, setOutput] = useState<{ type: unknown; value: unknown }>(null);

  const cleanOutput = () => setOutput(null);

  const executeCommand: BaseCommand = useCallback((command, type) => {
    cleanOutput();
    try {
      window.electronAPI.executeBashCommand(command).then((result) => {
        if (!result.success) {
          setScriptState("failed");
          setOutput({ type, value: result.stderr });
          return;
        }
        setScriptState("completed");
        setOutput({ type, value: result.stdout });
      });
    } catch (error) {
      setScriptState("failed");
      setOutput({ type, value: error });
      console.error("Failed to execute command:", error);
    }
  }, []);

  const executeScript: BaseCommand = useCallback(
    (scriptPath, type, subscribe = false) => {
      setScriptState("started");
      cleanOutput();
      try {
        setScriptState("in_progress");
        if (subscribe) {
          window.electronAPI.onScriptOutput((res) => {
            if (res.type === "stderr") {
              window.electronAPI.killProcess(res.processId);
            }
            setOutput({ type, value: res.data });
          });
        }
        window.electronAPI.executeBashScript(scriptPath).then((result) => {
          if (!result.success) {
            setScriptState("failed");
            setOutput({ type, value: result.stderr });
          } else {
            setScriptState("completed");
            setOutput({ type, value: result.stdout });
          }
        });
      } catch (error) {
        setScriptState("failed");
        setOutput({ type, value: error });
        console.error("Failed to execute script:", error);
      }
    },
    [],
  );

  return { scriptState, output, executeScript, executeCommand };
};
