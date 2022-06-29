import { Hono } from "hono";
import { RegExpRouter } from "hono/router/reg-exp-router";
import {SignJWT, jwtVerify} from "jose";

export const app = new Hono({ router: new RegExpRouter() });

app.get("/token", async (c) => {
  let token;
  let keyPair;
  let strPublicKey;
  try {
    keyPair = await crypto.subtle.generateKey(
      {
        name: "RSA-PSS",
        modulusLength: 2048, //can be 1024, 2048, or 4096
        publicExponent: new Uint8Array([0x01, 0x00, 0x01]),
        hash: { name: "SHA-256" }, //can be "SHA-1", "SHA-256", "SHA-384", or "SHA-512"
      },
      true,
      ["sign", "verify"]
    );

    let exported = await crypto.subtle.exportKey("spki", keyPair.publicKey);
    let exportedAsString = ab2str(exported);
    let exportedAsBase64 = btoa(exportedAsString);
    strPublicKey = `-----BEGIN PUBLIC KEY-----${exportedAsBase64}-----END PUBLIC KEY-----`;

    token = await new SignJWT({ "urn:example:claim": true })
      .setProtectedHeader({ alg: "PS256" })
      // .setProtectedHeader({ alg: "PS512" })
      .setIssuedAt()
      .setIssuer("urn:example:issuer")
      .setAudience("urn:example:audience")
      .setExpirationTime("2h")
      .sign(keyPair.privateKey);
    const { payload, protectedHeader } = await jwtVerify(
      token,
      keyPair.publicKey,
      {
        issuer: "urn:example:issuer",
        audience: "urn:example:audience",
      }
    );

    return c.json({
      token,
      payload,
      protectedHeader,
      publicKey: strPublicKey,
    });
  } catch (e) {
    return c.html(JSON.stringify(e));
  }
});

function ab2str(buf) {
  return String.fromCharCode.apply(null, new Uint8Array(buf));
}

export default app;
