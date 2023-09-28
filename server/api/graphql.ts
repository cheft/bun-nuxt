import { createYoga } from 'graphql-yoga'
import { createContext } from '../utils/context'
import { schema } from '../utils/schema'

const yoga = createYoga({ schema, context: createContext, graphqlEndpoint: '/api/graphql' })

export default defineEventHandler((event) => {
  const { req, res } = event.node
  return yoga(req, res)
})
