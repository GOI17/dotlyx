import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    include: ["**/*.test.ts(x)"],
    setupFiles: "./src/tests/setup.unit.ts",
    environment: "happy-dom",
  },
});
