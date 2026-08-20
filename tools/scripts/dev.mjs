import { spawn } from 'node:child_process';
import fs from 'node:fs';

const catalog = 'src/ShadBlazor.FreeIcon/Resources/lets-icons.json';
if (!fs.existsSync(catalog)) {
  console.error('Icon catalog is missing. Run tools\\commands\\bootstrap.cmd (Windows) or ./tools/commands/bootstrap.sh first.');
  process.exit(2);
}

const children = [];
const start = (command, args) => {
  const child = spawn(command, args, { shell: true, stdio: 'inherit' });
  children.push(child);
  child.on('exit', code => {
    if (code && code !== 0) {
      console.error(`${command} exited with ${code}`);
      shutdown(code);
    }
  });
};

function shutdown(code = 0) {
  for (const child of children) {
    if (!child.killed) child.kill('SIGTERM');
  }
  setTimeout(() => process.exit(code), 100);
}

process.on('SIGINT', () => shutdown(0));
process.on('SIGTERM', () => shutdown(0));

start('npm', ['run', 'css:watch']);
start('dotnet', ['watch', '--project', 'preview/ShadBlazor.FreeIcon.Preview/ShadBlazor.FreeIcon.Preview.csproj', '--launch-profile', 'http']);
