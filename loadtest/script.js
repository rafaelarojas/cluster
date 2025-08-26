import http from "k6/http";
import { sleep, check } from "k6";

export let options = {
  vus: 50,
  duration: "1m",
};

export default function () {
  const res = http.get("http://host.docker.internal:8080/"); 
  check(res, { "status 200": (r) => r.status === 200 });
  sleep(1);
}
