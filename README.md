# Nuxt 3 Minimal Starter

Look at the [Nuxt 3 documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.

## Setup

Make sure to install the dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

## Development Server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev

# pnpm
pnpm run dev

# yarn
yarn dev

# bun
bun run dev
```

## Production

Build the application for production:

```bash
# npm
npm run build

# pnpm
pnpm run build

# yarn
yarn build

# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview

# pnpm
pnpm run preview

# yarn
yarn preview

# bun
bun run preview
/home/lighthouse/bun-nuxt/package.json
# production
bun install -g pm2
bun install -g cross-env
bun run prod
```


Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.

## Prisma
```bash
npx prisma init --datasource-provider sqlite 

npx prisma migrate dev --name init

bunx prisma generate

bunx prisma studio
```


```js
let villages = []
document.querySelectorAll('tspan').forEach((e)=> {
//   console.log(e.textContent)
  if (!e.textContent.includes('（')) {
    villages.push(e.textContent)
  }
})
console.log(villages)
```