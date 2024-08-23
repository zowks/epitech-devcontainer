import { parseArgs } from 'node:util';

export type ParsedOptions = {
    help: boolean;
    watch: boolean;
    "no-check-ignore": boolean;
};

export type ParsedArguments = {
    options: ParsedOptions;
    paths: string[];
};

export default function parseArguments(args: string[]): ParsedArguments {
    const { values, positionals } = parseArgs({
        args,
        options: {
            help: {
                type: 'boolean',
                default: false,
                short: 'h'
            },
            watch: {
                type: 'boolean',
                default: false,
                short: 'w'
            },
            "no-check-ignore": {
                type: 'boolean',
                default: false,
                short: 'c'
            }
        },
        allowPositionals: true,
        strict: false
    });

    return { options: values as ParsedOptions, paths: positionals.slice(2) };
}
