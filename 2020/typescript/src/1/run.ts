import * as File from "../shared/file";

const FINAL_TARGET = 2020;
const path = __dirname + "/input.txt";

const processContents = (lines: string[]) => lines
  .map(line => Number(line))
  .filter(num => !isNaN(num) && num !== 0);

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

    const partnerTerms = findSumTerms(numbersToSearch, termsToFind - 1, subTarget);
    if (partnerTerms.length === 0)
      continue;

    return [possibleTerm, ...partnerTerms];
  }

  return [];
};

const multiplyTerms = (terms: number[]) =>
  terms.reduce((previousValue, currentValue) => previousValue * currentValue, 1);

const solve = (numbers: number[], terms: number): number =>
  multiplyTerms(findSumTerms(numbers, terms, FINAL_TARGET));

const solveForMultipleTerms = (numbers: number[], maxTerms: number) => {
  return new Array(maxTerms)
    .fill(0)
    .map((_, i) => solve(numbers, i + 1))
    .map((result, i) => ({terms: i + 1, solution: result}))
    .filter(result => result.solution !== 1)
    .map(result => `${result.terms} Terms: ${result.solution}`)
    .join("\n");
};

export function run(args: string[]) {
  const max = Number(args[0]);

  return File.readAllLines(path)
    .then(processContents)
    .then(numbers => solveForMultipleTerms(numbers, max));
}
