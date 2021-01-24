import * as fs from "fs";
import {promisify} from "util";

const FINAL_TARGET = 2020;
const path = __dirname + "/input.txt";

const processContents = (data: string) => {
  const numbers = data.split("\n")
    .map(line => Number(line))
    .filter(num => !isNaN(num) && num !== 0);

  return numbers;
};

// const findSumTerms = (numbers: number[]) : [first: number, second: number] => {
//   const firstTerm = numbers.filter(num => numbers.includes(TARGET - num))[0];
//   return [firstTerm, TARGET - firstTerm];
// };

const findSumTerms = (numbers: number[], termsToFind: number, target: number): number[] => {
  if (termsToFind === 1) {
    return numbers.includes(target) ? [target] : [];
  }

  for (let i = 0; i < numbers.length; i++) {
    // Check if the required term to make up the target exists in the numbers
    const possibleTerm = numbers[i];

    const subTarget = target - possibleTerm;
    if (subTarget <= 0)
      continue;

    const numbersToSearch = numbers
      .slice(i + 1) // Search the subset of number
      .filter(n => n <= subTarget); // Ignore numbers larger than the new target

    if (numbersToSearch.length === 0)
      continue;

    // Skip this term if it's impossible with the search space
    if (!numbersToSearch.find(n => n <= subTarget))
      continue;

    console.log(`Possible: ${possibleTerm}, Target: ${subTarget}, in ${numbersToSearch}`);

    const partnerTerms = findSumTerms(numbersToSearch, termsToFind - 1, subTarget);
    if (partnerTerms.length === 0)
      continue;

    console.log(`Found partner terms ${partnerTerms} for ${possibleTerm}`);

    return [possibleTerm, ...partnerTerms];
  }

  return [];
};

const multiplyTerms = (terms: number[]) =>
  terms.reduce((previousValue, currentValue) => previousValue * currentValue, 1);

const solve = (numbers: number[], terms: number): number =>
  multiplyTerms(findSumTerms(numbers, terms, FINAL_TARGET));

export function run(): Promise<string> {
  const readFile = promisify(fs.readFile);
  return readFile(path, "utf8")
    .then(processContents)
    .then(numbers => [
      solve(numbers, 2),
      solve(numbers, 3)
    ])
    .then(result => "Part 1: " + result[0] + "\n" + "Part 2: " + result[1]);
}
