import {readAllLines} from "../shared/file";

const PATH = __dirname + "/input.txt";

const START_POSITION: Coordinate = {
  x: 0,
  y: 0
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

export async function run(args: string[]): Promise<any> {
  const movements: Coordinate[] = [
    {x: 3, y: 1},
    {x: 1, y: 1},
    {x: 5, y: 1},
    {x: 7, y: 1},
    {x: 1, y: 2},
  ];

  const map = await readAllLines(PATH).then(parseMap);
  return movements
    .map(movement => travelToExit(map, movement))
    .reduce((prev, curr) => prev * curr, 1);
}

const parseMap = (lines: string[]): Map => lines.map(parseCell);
const parseCell = (line: string): Cell[] => Array.from(line).map(char => char as Cell);

/**
 * Travel to exit (outside the map) from start position,
 * @returns number of hit trees
 */
const travelToExit = (map: Map, movement: Coordinate, currentPosition?: Coordinate): number => {
  const nextPosition =
    transpose(
      move(currentPosition ?? START_POSITION, movement),
      map);

  // We have exited if the Y position is outside the bounds
  if (nextPosition.y >= map.length) {
    return 0;
  }

  // Otherwise, keep travelling
  const nextCell = map[nextPosition.y][nextPosition.x];
  return travelToExit(map, movement, nextPosition) + (nextCell === Tree ? 1 : 0);
};

/**
 * Get next position given the current position.
 * @param position
 * @returns next position
 */
const move = (position: Coordinate, movement: Coordinate): Coordinate => ({
  x: position.x + movement.x,
  y: position.y + movement.y
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