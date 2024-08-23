declare global {
    interface String {
        readonly strong: string;
        readonly underline: string;
        readonly italic: string;
        readonly grey: string;
        readonly blue: string;
        readonly yellow: string;
        readonly red: string;
        readonly darkRed: string;
    }
}

Object.defineProperties(String.prototype, {
    strong: { get() { return `\x1b[1m${this}\x1b[22m` } },
    underline: { get() { return `\x1b[4m${this}\x1b[24m` } },
    italic: { get() { return `\x1b[3m${this}\x1b[23m` } },
    grey: { get() { return `\x1b[38;5;232m${this}\x1b[39m` } },
    blue: { get() { return `\x1b[38;5;12m${this}\x1b[39m` } },
    yellow: { get() { return `\x1b[38;5;11m${this}\x1b[39m` } },
    red: { get() { return `\x1b[38;5;9m${this}\x1b[39m` } },
    darkRed: { get() { return `\x1b[38;5;160m${this}\x1b[39m` } }
});

import parseArguments from './modules/parseArguments';
import categorizePaths from './modules/categorizePaths';

import watch from './watch';
import report from './report';


const { options, paths } = parseArguments(Bun.argv);

if (options.help) {
    Bun.write(Bun.stdout, "Usage: coding-style [options] [path ...]\n\n");
    Bun.write(Bun.stdout, "Options:\n");
    Bun.write(Bun.stdout, " -h, --help\t\tShow this help message and exit\n");
    Bun.write(Bun.stdout, " -w, --watch\t\tWatch files and directories for changes\n");
    Bun.write(Bun.stdout, " -i, --no-check-ignore\tDo not use git check-ignore to filter files\n");
    process.exit(0);
}

if (options.watch)
    watch(await categorizePaths(paths), options);
else
    report(await categorizePaths(paths), options);
