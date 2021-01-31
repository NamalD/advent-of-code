import {readAllLines} from "../shared/file";

const PATH = __dirname + "/input.txt";

const UNDEFINED_FIELD = "" as const;
const REQUIRED_FIELDS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] as const;
const OPTIONAL_FIELDS = ["cid"] as const;
type RequiredField = typeof REQUIRED_FIELDS[number];
type OptionalField = typeof OPTIONAL_FIELDS[number];
type Field = RequiredField | OptionalField | typeof UNDEFINED_FIELD;

const VALID_EYE_COLOURS = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"];

type Passport = Partial<Record<Field, string>>;

export function run(): Promise<number> {
  return readAllLines(PATH, false)
    .then(cleanLines)
    .then(parseLinesAsPassports)
    .then(validate)
    .then(valid => valid.length);
}

/**
 * Merge lines for a single passport into a single line.
 * @param lines
 */
const cleanLines = (lines: string[]): string[] =>
  lines.join(" ").split("  ");

const parseLinesAsPassports = (lines: string[]): Passport[] =>
  lines.map(parseLineAsPassport);

function parseLineAsPassport(line: string) {
  const fields = line.split(" ");
  const passportFields = fields.map(parseField);
  const passport: Passport = mergePassportFields(passportFields);
  return passport;
}

const parseField = (field: string): Passport => {
  const [fieldName, value] = field.split(":");
  const fieldType = fieldName as Field;

  return ({
    [fieldType]: value
  });
};

const mergePassportFields = (fields: Passport[]) => fields.reduce(
  (acc, curr) => ({...acc, ...curr}),
  {}
);

const validate = (passports: Passport[]): Passport[] => passports
  .map(passport => ({
    passport: passport,
    isValid: validatePassport(passport)
  }))
  .filter(passport => passport.isValid)
  .map(passport => passport.passport);

const validatePassport = (passport: Passport): boolean => {
  const requiredFields = REQUIRED_FIELDS
    .map(field => (
      {
        field,
        value: passport[field],
        validate: validations[field]
      }));

  if (!requiredFields.every(f => f.value != null)) {
    return false;
  }

  return requiredFields
    .map(setup => ({
      field: setup.field,
      value: setup.value,
      isValid: setup.value === undefined ? false : setup.validate(setup.value)
    }))
    .every(validation => validation.isValid);
};

const between = (value: number, min: number, max: number): boolean => value >= min && value <= max;

const validations: Record<RequiredField, (value: string) => boolean> = {
  byr: value => between(Number(value), 1920, 2002),
  iyr: value => between(Number(value), 2010, 2020),
  eyr: value => between(Number(value), 2020, 2030),
  hgt: value => validateHeight(value),
  hcl: value => validateHairColour(value),
  ecl: value => VALID_EYE_COLOURS.includes(value),
  pid: value => (value.match(/^[0-9]{9}$/)?.length ?? -1) > 0,
};

const validateHeight = (height: string): boolean => {
  const unit = height.indexOf("cm") > 0
    ? "cm"
    : height.indexOf("in") > 0
      ? "in"
      : undefined;

  if (unit === undefined)
    return false;

  const value = Number(height.substring(0, height.indexOf(unit)));
  switch (unit) {
    case "cm":
      return between(value, 150, 193);
    case "in":
      return between(value, 59, 76);
  }
};

const validateHairColour = (colour: string): boolean => {
  const matches = colour.match(/^#[0-9a-f]{6}$/) ?? [];
  return matches.length > 0;
};
