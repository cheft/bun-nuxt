// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  nitro: {
    compressPublicAssets: { gzip: true, brotli: true },
  },
  devtools: { enabled: true }
})
