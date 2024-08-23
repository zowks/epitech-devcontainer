import type { CategorizedPaths } from "./modules/categorizePaths";
import type { ParsedOptions } from "./modules/parseArguments";

import collectFiles from "./modules/collectFiles";
import gitCheckIgnore from "./modules/gitCheckIgnore";
import bananaVera from "./modules/bananaVera";
import printReport from "./modules/printReport";

export default async function report(categorizedPaths: CategorizedPaths, options: ParsedOptions) {
    const collectedFiles = await collectFiles(categorizedPaths.files, categorizedPaths.directories);
    const filePool = (options["no-check-ignore"]) ? collectedFiles : gitCheckIgnore(collectedFiles);
    if (!filePool.length) {
        Bun.write(Bun.stderr, "No files to check\n".yellow.strong);
        if (!options["no-check-ignore"])
            Bun.write(Bun.stderr, "You may want to add '--no-check-ignore' to check all files.\n".grey.italic);

        process.exit(0);
    }

    const report = bananaVera(filePool);
    printReport(report);

    if (!Object.entries(report))
        process.exit(0);
    process.exit(1);
}
