import { expect, test } from "vitest";
import { render } from "vitest-browser-react";

import { App } from "./App";

test("renders name", async () => {
  const screen = render(<App />);

  expect(
    screen.getByRole("heading", {
      hasText: "Hello from React + Electron!",
    }),
  ).toBeInTheDocument();
});
