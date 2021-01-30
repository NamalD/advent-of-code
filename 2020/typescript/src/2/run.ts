import {readAllLines} from "../shared/file";

const PATH = __dirname + "/input.txt";

type PasswordWithPolicy = { value: string; min: number; max: number, validationChar: string };

function parseInput(lines: string[]): PasswordWithPolicy[] {
  return lines.map(parseLine);
}

function parseLine(line: string): PasswordWithPolicy {
  const separatorIndex = line.indexOf("-");
  return {
    min: extractNumber(line, 0, separatorIndex),
    max: extractNumber(line, separatorIndex + 1, line.indexOf(" ")),
    validationChar: line.substring(line.indexOf(" ") + 1, line.indexOf(":")),
    value: line.substring(line.indexOf(":") + 2)
  };
}

function extractNumber(line: string, start: number, end: number) {
  const substring = line.substring(start, end);
  return Number(substring);
}

function filterValid (passwords: PasswordWithPolicy[], validator: (password: PasswordWithPolicy) => boolean) : PasswordWithPolicy[] {
  return passwords.filter(password => validator(password));
}

function partOne(passwordWithPolicy: PasswordWithPolicy): boolean {
  const charRegEx = new RegExp(passwordWithPolicy.validationChar, "g");
  const chars = passwordWithPolicy.value.match(charRegEx);
  return chars != null
    && chars.length >= passwordWithPolicy.min
    && chars.length <= passwordWithPolicy.max;
}

function partTwo(password: PasswordWithPolicy): boolean {
  const minCharMatches = password.value[password.min - 1] === password.validationChar;
  const maxCharMatches = password.value[password.max - 1] === password.validationChar;

  // XOR
  return minCharMatches
    ? !maxCharMatches
    : maxCharMatches;
}

export function run(args: string[]): Promise<any> {
  const validator = args[0] === "1" ? partOne : partTwo;

  return readAllLines(PATH)
    .then(parseInput)
    .then(passwords => filterValid(passwords, validator))
    .then(validPasswords => validPasswords.length)
    .catch(console.error);
}