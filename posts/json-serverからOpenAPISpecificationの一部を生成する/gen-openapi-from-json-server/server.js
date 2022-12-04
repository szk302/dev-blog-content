const express = require("express");
const fs = require("fs");
const fetch = require("node-fetch");
const db = require("./db.json");

const BASE_URL = "http://localhost:3000";

const keys = Object.keys(db);

const postProcess = async (cb) => {
  for (const key of keys) {
    await pluralRoutesRequest(key, db[key][0]);
    // queryパラメータはキャプチャしてくれない
    // await filterRequest(key, value);
  }
  cb();
};

// Plural routes
const pluralRoutesRequest = async (path, data) => {
  // GET    /posts
  let response = await fetch(`${BASE_URL}/${path}`);
  // GET    /posts/1
  response = await fetch(`${BASE_URL}/${path}/${data.id}`);
  // PUT    /posts/1
  response = await fetch(`${BASE_URL}/${path}/${data.id}`, {
    method: "PUT",
    body: JSON.stringify(data),
    headers: { "Content-Type": "application/json" },
  });
  // PATCH  /posts/1
  response = await fetch(`${BASE_URL}/${path}/${data.id}`, {
    method: "PATCH",
    body: JSON.stringify(data),
    headers: { "Content-Type": "application/json" },
  });
  // DELETE /posts/1
  response = await fetch(`${BASE_URL}/${path}/${data.id}`, {
    method: "DELETE",
  });
  // POST   /posts
  response = await fetch(`${BASE_URL}/${path}`, {
    method: "POST",
    body: JSON.stringify(data),
    headers: { "Content-Type": "application/json" },
  });
};

// Filter
const filterRequest = async (path, list) => {
  let query = Object.entries(list[0]).reduce((previous, [key, value]) => {
    if (key === "id") {
      return previous;
    }

    previous = previous ? `${previous}&` : previous;

    return `${previous}${key}=${value}`;
  }, "");

  // GET /posts?title=json-server&author=typicode
  let response = await fetch(`${BASE_URL}/${path}?${query}`);
  // GET /posts?id=1&id=2
  response = await fetch(
    `${BASE_URL}/${path}/?id=${list[0].id}&id=id=${list[1].id}`
  );
};

const expressOasGenerator = require("express-oas-generator");
const jsonServer = require("json-server");
const server = jsonServer.create();

server.use(express.json()); // for parsing application/json
server.use(express.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

// expressOasGenerator.init(server, {});
expressOasGenerator.handleResponses(server, {
  swaggerUiServePath: "api-docs",
  specOutputPath: "./openapi.json",
  predefinedSpec: {},
  writeIntervalMs: 60 * 1000,
  // mongooseModels: ["User", "Student"],
  mongooseModels: [],
  tags: keys,
  ignoredNodeEnvironments: ["production"],
  alwaysServeDocs: true,
  specOutputFileBehavior: "PRESERVE",
  // specOutputFileBehavior: "RECREATE",
  swaggerDocumentOptions: {},
});

const router = jsonServer.router("db.json");
const middlewares = jsonServer.defaults();

server.use(middlewares);
server.use(router);

expressOasGenerator.handleRequests();

const s = server.listen(3000, () => {
  // console.info("JSON Server is running");
  postProcess(() => {
    expressOasGenerator.getSpecV3((err, spec) => {
      // console.log(JSON.stringify(spec));
      const paths = spec.paths;
      delete paths["/db"];
      delete paths["/{resource}/{id}/{nested}"];
      fs.writeFileSync("my-openapi_v3.json", JSON.stringify(spec));
      s.close(() => {
        console.info("Done.");
      });
    });
  });
});
