import { app } from "./index";

describe("Test the application", () => {
  it("Should return 200 response", async () => {
    const res = await app.request("http://localhost/");
    expect(res.status).toBe(200);
  });

  it("Should return 401 response", async () => {
    const res = await app.request("http://localhost/auth");
    expect(res.status).toBe(401);
  });

  it("Should return 200 response", async () => {
    const res = await app.request("http://localhost/auth", {
      headers: new Headers({
        Authorization: "Basic " + btoa("hono:acoolproject"),
      }),
    });

    expect(res.status).toBe(200);
  });

  it("Should return 200 response", async () => {
    const res = await app.request("http://localhost/book/123");
    expect(res.status).toBe(200);
  });

  it("Should return 201 response", async () => {
    const res = await app.request("http://localhost/book", {
      method: "post",
    });
    expect(res.status).toBe(201);
  });
});
