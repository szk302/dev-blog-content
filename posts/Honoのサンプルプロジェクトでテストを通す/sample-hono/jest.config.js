module.exports = {
  testEnvironment: "miniflare",
  testMatch: [
    "**/test/**/*.+(ts|tsx|js)",
    "**/src/**/(*.)+(spec|test).+(ts|tsx|js)",
  ],
  transform: {
    "^.+\\.(ts|tsx)$": [
      "esbuild-jest",
      {
        sourcemap: true
      },
    ],
  },
  coverageDirectory: "reports/coverage",
  collectCoverage: true,
  coverageReporters: ["json", "lcov", "text", "html"],
  collectCoverageFrom: ["src/**/*.ts", "!**/node_modules/**"],
};
