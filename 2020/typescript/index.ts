const [, , day] = process.argv;
const path = `${__dirname}/src/${day}/run`;

import(path).then(async solver => {
  const solverArgs = process.argv.slice(3);
  const result = await solver.run(solverArgs);
  console.log(result);
});
