import { Hono } from 'hono'
import { poweredBy } from 'hono/powered-by'
import { basicAuth } from 'hono/basic-auth'
import { RegExpRouter } from "hono/router/reg-exp-router";

// export const app = new Hono();
export const app = new Hono({ router: new RegExpRouter() });

// Builtin middleware
app.use('*', poweredBy())
// Basic Auth
app.use(
  '/auth/*',
  basicAuth({
    username: 'hono',
    password: 'acoolproject',
  })
)

// Custom middleware
app.use('*', async (c, next) => {
  await next()
  c.header('X-message', 'Hono is a cool project')
})

// Routing
app.get('/', async (c) => c.html('<h1>Hello Hono!</h1>'))
app.get('/auth/*', async (c) => c.text('You are authorized'))

// Nested route
const book = new Hono()
// Named path parameters
book.get('/:id', (c) => {
  const id = c.req.param('id')
  return c.json({ 'Your book ID is': id })
})
book.post('/', (c) => c.text('Book is created', 201))
app.route('/book', book)

export default app
