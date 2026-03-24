import * as Consumet from '@consumet/extensions';

console.log('Consumet exports:', Consumet);

// TEMP: stop using BOOKS so TS compiles
export default async (req: any, res: any) => {
  res.send('Check logs for Consumet exports');
};
