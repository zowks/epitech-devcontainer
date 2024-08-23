import type { CategorizedPaths as T } from './categorizePaths';
import { readdir } from 'node:fs/promises';

export default async function collectFiles(files: T['files'], directories: T['directories']): Promise<string[]> {
    for (const directory of directories) {
        (await readdir(directory, { recursive: true, withFileTypes: true }))
            .filter(dirent => dirent.isFile())
            .forEach(file => {
                if (file.parentPath)
                    files.add(`${file.parentPath}/${file.name}`);
                else
                    files.add(file.name);
            })
    }

    return Array.from(files);
}
