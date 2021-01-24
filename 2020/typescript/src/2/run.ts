import {readAllLines} from "../shared/file";

const PATH = __dirname + "/input.txt";

function parseInput(lines: string[]) {
  return lines.map(parseLine);
}

function extractNumber(line: string, start: number, end: number) {
  const minSubstring = line.substring(0, end);
  const min = Number(minSubstring);
  return min;
}

function parseLine(line: string) {
  const separatorIndex = line.indexOf("-");
  const min = extractNumber(line, 0, separatorIndex);
  const max = extractNumber(line, separatorIndex + 1, line.indexOf(" "));

  return { min, max };
}

export function run(args: string[]) : Promise<any> {
  return readAllLines(PATH)
    .then(parseInput)
    .catch(console.error);
}