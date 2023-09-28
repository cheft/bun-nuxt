import { usePrisma } from "../utils/prisma";

export default defineEventHandler(async (event) => {
  const prisma = usePrisma();
  console.log(event)
  return {test: "hello"}
})
