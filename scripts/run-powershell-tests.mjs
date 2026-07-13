import { spawnSync } from "node:child_process";

const executable = process.platform === "win32" ? "powershell" : "pwsh";
const commonArgs = process.platform === "win32"
  ? ["-NoProfile", "-ExecutionPolicy", "Bypass"]
  : ["-NoProfile"];
const testFiles = [
  "tests/static-site-checks.ps1",
  "tests/build-accessibility-checks.ps1",
  "tests/deploy-config-checks.ps1"
];

for (const testFile of testFiles) {
  const result = spawnSync(executable, [...commonArgs, "-File", testFile], {
    stdio: "inherit"
  });

  if (result.error) {
    console.error(`Unable to run ${testFile} with ${executable}: ${result.error.message}`);
    process.exit(1);
  }

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}
