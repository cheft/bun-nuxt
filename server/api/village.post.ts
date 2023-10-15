import { defineEventHandler,readBody } from "h3";
import { usePrisma } from "../utils/prisma";

export default defineEventHandler(async (event) => {
  let data = await readBody(event);
  const prisma = usePrisma();
  if (data.id) {
    console.log(data.id, 11111)
    let result = await prisma.village.update({
      where: { id: data.id },
      data: { name: data.name, desc: data.desc, networkNum: data.networkNum }
    })
  } else {
    let result = await prisma.village.create({data})
    return result;
  }

  return { }
})
