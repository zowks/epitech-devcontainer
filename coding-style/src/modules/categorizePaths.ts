import { exists, stat } from 'node:fs/promises';
import { normalize, isAbsolute, relative } from 'node:path/posix';

export type CategorizedPaths = {
    files: Set<string>;
    directories: Set<string>;
};

const excludedDirectories = ['.git', 'bonus', 'tests'] as const;
function isExcluded(path: string): boolean {
    for (const excludedDirectory of excludedDirectories)
        if (path.startsWith(excludedDirectory))
            return true;

    return false;
}

export default async function CategorizePaths(paths: string[]): Promise<CategorizedPaths> {
    const files: Set<string> = new Set();
    const directories: Set<string> = new Set();

    if (!paths.length)
        directories.add('.');

    for (let path of paths) {
        if (!await exists(path)) {
            Bun.write(Bun.stderr, `Path '${path}' does not exist !\n`.red.strong);
            process.exit(128);
        }

        if (isAbsolute(path))
            path = relative('.', path);
        else
            path = normalize(path);

        if (isExcluded(path))
            continue;

        const pathStats = await stat(path);
        if (pathStats.isFile()) {
            files.add(path);
            continue;
        }

        if (pathStats.isDirectory()) {
            directories.add(path);
            continue;
        }

        Bun.write(Bun.stderr, `Path '${path}' is not a file nor a directory !\n`.red.strong);
        process.exit(128);
    }

    return { files, directories };
}
