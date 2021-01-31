import {promisify} from "util";
import * as fs from "fs";

export function readAllLines(path: string, filterBlankLines = true) : Promise<string[]> {
  const readFile = promisify(fs.readFile);
  return readFile(path, "utf8")
    .then(data => data.split("\n").filter(line => !filterBlankLines || line !== ""))
    .catch(err => {
      console.log(err);
      return [];
    });
}
