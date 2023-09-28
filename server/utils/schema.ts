import { makeExecutableSchema } from '@graphql-tools/schema'
import type { Village } from '@prisma/client'
import type { GraphQLContext } from './context'
 
const typeDefinitions =  `
  type Query {
    hello: String!
    village(id: ID!): Village!
    villageList: [Village!]!
  }

  type Mutation {
    postVillage(data: CreateVillage): Village!
    deleteVillage(id: ID!): Village!
  }

  input CreateVillage {
    name: String
    desc: String
  }
 
  type Village {
    id: ID!
    name: String!
    desc: String!
  }
`

const resolvers = {
  Query: {
    hello: () => `This is GraphQL API`,
    village: (parent: unknown, args: { id: number }, context: GraphQLContext) => context.prisma.village.findUnique({where: {id: +args.id}}),
    villageList: (parent: unknown, args: {}, context: GraphQLContext) => context.prisma.village.findMany()
  },
  Mutation: {
    async postVillage(
      parent: unknown,
      args: { data: {name: string; desc: string }},
      context: GraphQLContext
    ) {
      const newVillage = await context.prisma.village.create({
        data: {
          name: args.data.name,
          desc: args.data.desc,
          networkNum : 0,
          graphIndex: 0,
          nameIndex :0,
          creator: 1,
          updateTime: new Date(),
        }
      })
      return newVillage
    },

    deleteVillage: (parent: unknown, args: {id: number}, context: GraphQLContext) => context.prisma.village.delete({where: {id: +args.id}})
  }
}
 
export const schema = makeExecutableSchema({
  resolvers: [resolvers],
  typeDefs: [typeDefinitions]
})
