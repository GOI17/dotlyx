import { describe, test, expect } from "vitest";
import { render, screen, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import { App } from "./App";

describe("App", () => {
  test("Should see dotlyx welcome banner", () => {
    render(<App />);

    const welcomeBanner = screen.getByRole("heading", {
      description: "Dotlyx welcome banner",
      name: "Welcome to Dotlyx!",
    });

    expect(welcomeBanner).toBeInTheDocument();
  });

  test.each([
    {
      description:
        "Dotlyx requirements check. This button will execute a script that checks if all required tools are available in your local.",
      name: "Requirements check",
    },
    {
      description:
        "Dotlyx init setup. This button will initialize everyting in your local to use dotlyx.",
      name: "Start setup",
    },
  ])("Should see dotlyx available options", (props) => {
    render(<App />);

    const requirementsCheck = screen.getByRole("button", {
      description: props.description,
      name: props.name,
    });

    expect(requirementsCheck).toBeInTheDocument();
  });
  describe("Requirements check", () => {
    test("Should be enabled", () => {
      render(<App />);

      const requirementsCheck = screen.getByRole("button", {
        name: "Requirements check",
      });

      expect(requirementsCheck).toBeEnabled();
    });

    test("Should be disabled after click", async () => {
      render(<App />);

      const requirementsCheck = screen.getByRole("button", {
        name: "Requirements check",
      });

      await userEvent.click(requirementsCheck);

      expect(requirementsCheck).toBeDisabled();
    });

    test("On click should display the requirements list", async () => {
      render(<App />);

      const requirementsCheck = screen.getByRole("button", {
        name: "Requirements check",
      });

      await userEvent.click(requirementsCheck);

      const requirementsList = screen.getByRole("list", {
        description: "Dotlyx requirements list",
      });

      [
        "✅ curl installed",
        "✅ git installed",
        "✅ python installed",
        "✅ nix installed",
      ].forEach((program) => {
        expect(requirementsList).toHaveTextContent(program);
      });
    });
  });
});
