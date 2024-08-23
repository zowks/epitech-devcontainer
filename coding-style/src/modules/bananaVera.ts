export type RuleType = 'FATAL' | 'MAJOR' | 'MINOR' | 'INFO';

export type RuleCode = {
    [code: string]: string;
}

export type Report = {
    [file: string]: {
        path: string;
        type: RuleType;
        code: string;
        description: string;
    }[]
}

const descriptions = (await Bun.file('/usr/local/lib/vera++/code_to_comment').text())
    .split('\n')
    .reduce((acc, line) => {
        if (!line)
            return acc;

        const tokens = line.split(':');
        acc[tokens[0]] = tokens[1].charAt(0).toUpperCase() + tokens[1].slice(1);

        return acc;
    }, {} as RuleCode);

export default function bananaVera(files: string[]): Report {
    const subprocess = Bun.spawnSync(['vera++', '--no-duplicate', '--profile', 'epitech', ...files]);
    if (subprocess.exitCode !== 0) {
        Bun.write(Bun.stderr, "An error occurred while running Vera++ !\n".red.strong);
        process.exit(128);
    }

    return String(subprocess.stdout)
        .split('\n')
        .reduce((acc, line) => {
            if (!line)
                return acc;

            const tokens = line.split(':');
            if (!acc[tokens[0]])
                acc[tokens[0]] = [];

            acc[tokens[0]].push({
                path: `${tokens[0]}:${tokens[1]}`,
                type: tokens[2].slice(1) as RuleType,
                code: tokens[3],
                description: descriptions[tokens[3]]
            });

            return acc;
        }, {} as Report);
}
