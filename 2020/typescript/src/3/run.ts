import {readAllLines} from "../shared/file";

const PATH = __dirname + "/input.txt";

const START_POSITION: Coordinate = {
  x: 0,
  y: 0
};

const MOVEMENT: Coordinate = {
  x: 3,
  y: 1
};

const Open = ".";
const Tree = "#";
type Cell = typeof Open | typeof Tree;

type Map = {
  [y: number]: Cell[];
  length: number;
}

type Coordinate = {
  x: number;
  y: number
};

export function run(args: string[]): Promise<any> {
  return readAllLines(PATH)
    .then(parseMap)
    .then(travelToExit);
}

const parseMap = (lines: string[]): Map => lines.map(parseCell);
const parseCell = (line: string): Cell[] => Array.from(line).map(char => char as Cell);

/**
 * Travel to exit (outside the map) from start position,
 * @returns number of hit trees
 */
const travelToExit = (map: Map, currentPosition?: Coordinate): number => {
  const nextPosition = transpose(move(currentPosition ?? START_POSITION), map);

  // We have exited if the Y position is outside the bounds
  if (nextPosition.y >= map.length) {
    console.log("exited map");
    return 0;
  }

  // DEBUG: Print the location we travelled to
  const nextCell = map[nextPosition.y][nextPosition.x];
  console.log(nextCell);

  // Otherwise, keep travelling
  return travelToExit(map, nextPosition) + (nextCell === Tree ? 1 : 0);
};

/**
 * Get next position given the current position.
 * @param position
 * @returns next position
 */
const move = (position: Coordinate): Coordinate => ({
  x: position.x + MOVEMENT.x,
  y: position.y + MOVEMENT.y
});

/**
 * Transpose position by wrapping around X-axis.
 * @param position
 * @param map
 */
const transpose = (position: Coordinate, map: Map): Coordinate => {
  const row =  map[position.y];
  if (row === undefined)
    return position;

  const xLength = row.length;
  return {
    x: position.x % xLength,
    y: position.y
  };
};