const sdk = require("node-appwrite");

const client = new sdk.Client()
  .setEndpoint("https://appwrite.yerbolat.com/v1") // Your API Endpoint
  .setProject("670121e5000ab490489e") // Your project ID
  .setKey(
    "6071eace594fea9c433d516f5fd68333b70ebf3c65cd227d3b730bbe7abe9ff28f929e748aafb886d6e55a39389d8de2711fcfe25ccfb7f93adbe2ab26c8de5b8c33343c585eb229af6196a78397bc67178f9d901bf1e04efa3b6a9365ab6ba850cd353bd32b5864bf50d8b2f1314ec49109400679453f37a16867b11e5c5580"
  ); // Your secret API key

const functions = new sdk.Functions(client);

async function getFunctionsList() {
  const result = await functions.list(
    [] // queries (optional)
  );
  console.log(result); // Use the result
}

getFunctionsList();
