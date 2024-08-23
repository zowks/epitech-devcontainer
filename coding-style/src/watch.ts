import type { CategorizedPaths } from "./modules/categorizePaths";
import type { ParsedOptions } from "./modules/parseArguments";

import { watch } from 'node:fs';
import gitCheckIgnore from "./modules/gitCheckIgnore";
import bananaVera from "./modules/bananaVera";
import printReport from "./modules/printReport";

function clearScreen() {
    process.stdout.cursorTo(0, 0);
    process.stdout.clearScreenDown();
}

export default (categorizedPaths: CategorizedPaths, options: ParsedOptions) => {
    const controller = new AbortController();
    process.on('SIGINT', () => controller.abort());

    for (const [category, paths] of Object.entries(categorizedPaths)) {
        for (const path of paths) {
            watch(
                path,
                { recursive: true, signal: controller.signal },
                (event, filename) => {
                    if (!filename || event !== 'change')
                        return;

                    let file = (category !== 'files') ? filename : path;
                    if (!options["no-check-ignore"])
                        file = gitCheckIgnore([file])[0];

                    if (!file)
                        return;

                    const report = bananaVera([file]);

                    clearScreen();
                    printReport(report);
                }
            );
        }
    }
    clearScreen();
};
