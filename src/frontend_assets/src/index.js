import { btconicpexample} from "../../declarations/btconicpexample";
import { Actor, HttpAgent } from '@dfinity/agent';
import { Principal } from "@dfinity/principal";
import { Ed25519KeyIdentity } from "@dfinity/identity";
import { AuthClient } from "@dfinity/auth-client";

function newIdentity() {
  const entropy = crypto.getRandomValues(new Uint8Array(32));
  const identity = Ed25519KeyIdentity.generate(entropy);
  localStorage.setItem("ic_vid_id", JSON.stringify(identity));
  console.log("New id is: " + JSON.stringify(identity));
  return identity;
}
var identity_array=[];
for (var i in [1, 2, 3, 4, 5]) {
   identity_array.push(newIdentity());
}
function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
async function demo() {
    for (let i = 0; i < 5; i++) {
        console.log(`Waiting ${i} seconds...`);
        await sleep(1000);
    }
    console.log('Done');
}
console.log("hello");
demo();

document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");

  const name = document.getElementById("name").value.toString();

  button.setAttribute("disabled", true);

  // Interact with foo actor, calling the greet method
  //const greeting = await frontend.greet(name);

  button.removeAttribute("disabled");

  //document.getElementById("greeting").innerText = greeting;

  return false;
});
