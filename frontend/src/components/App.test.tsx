import { describe, test, expect } from "vitest";
import { render, screen } from "@testing-library/react";

import { App } from "./App";

describe("App unit tests", () => {
  test("Should exists welcome message", () => {
    render(<App />);

    const welcomeMessage = screen.getByText("Hello from React + Electron!");

    expect(welcomeMessage).toBeDefined();
  });
});
