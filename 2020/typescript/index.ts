const [, , day] = process.argv;
const path = `${__dirname}/src/${day}/run`;

import(path).then(async solver => {
  const result = await solver.run();
  console.log(result);
});
