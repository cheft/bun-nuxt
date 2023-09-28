import { usePrisma } from "../utils/prisma";

export default defineEventHandler(async (event) => {
  const prisma = usePrisma();
  return await prisma.village.findMany();
})
