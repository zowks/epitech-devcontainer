export default function gitCheckIgnore(files: string[]): string[] {
    if (!files.length)
        return [];

    const subprocess = Bun.spawnSync(['git', 'check-ignore', '--verbose', '--non-matching', ...files]);
    if (subprocess.exitCode === 128) {
        Bun.write(Bun.stderr, 'An error occurred while running git check-ignore !\n'.red.strong);
        process.exit(128);
    }

    return String(subprocess.stdout)
        .split('\n')
        .filter(line => line.startsWith('::\t'))
        .map(line => line.slice(3));
}
