// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: ["@bg-dev/nuxt-naiveui"],
  nitro: {
    compressPublicAssets: { gzip: true, brotli: true },
  },
  devServer: {
    host: '0.0.0.0',
  }
  // devtools: { enabled: true }
})
