import type { Report } from "./bananaVera";

const typeToColor = {
    FATAL: 'darkRed',
    MAJOR: 'red',
    MINOR: 'yellow',
    INFO: 'blue'
} as const;

export default function printReport(report: Report): void {
    const counts = { FATAL: 0, MAJOR: 0, MINOR: 0, INFO: 0 };

    for (const [file, errors] of Object.entries(report)) {
        Bun.write(Bun.stdout, `${file}:\n\n`.strong.underline);

        for (const error of errors) {
            const header = ` ⏺ ${error.type.padEnd(5)} ${error.code}: `.strong;
            Bun.write(Bun.stdout, `${header}${error.description}\n`[typeToColor[error.type]]);
            Bun.write(Bun.stdout, `   ${error.path.grey.italic}\n\n`);

            counts[error.type]++;
        }

        Bun.write(Bun.stdout, '\n');
    }

    Bun.write(
        Bun.stdout,
        Object.entries(counts)
            .map(([type, count]) => `${count} ${type}`[typeToColor[type as keyof typeof typeToColor]].strong)
            .join(' | ') + '\n'
    );
}
