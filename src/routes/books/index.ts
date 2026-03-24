import * as Consumet from '@consumet/extensions';

console.log('Consumet exports:', Consumet);

// Minimal valid handler
export default async function handler(req: any, res: any) {
  res.send('OK - check logs');
}
