import { defineEventHandler,readBody } from "h3";
import { usePrisma } from "../utils/prisma";

export default defineEventHandler(async (event) => {
  let data = await readBody(event);
  const prisma = usePrisma();
  if (data.id) {
    let result = await prisma.villageMark.update({
      where: { id: data.id },
      data: { name: data.name, desc: data.desc, networkNum: data.networkNum }
    })
  } else {
    let result = await prisma.villageMark.create({data})
    return result;
  }

  return { }
})
