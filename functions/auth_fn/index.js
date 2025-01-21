const sdk = require("./node_modules/node-appwrite/dist");

const client = new sdk.Client();
const account = new sdk.Account(client);
const users = new sdk.Users(client);

client
  .setEndpoint("https://appwrite.yerbolat.com/v1") // Your API Endpoint
  .setProject("670121e5000ab490489e") // Your project ID
  .setKey(
    "6071eace594fea9c433d516f5fd68333b70ebf3c65cd227d3b730bbe7abe9ff28f929e748aafb886d6e55a39389d8de2711fcfe25ccfb7f93adbe2ab26c8de5b8c33343c585eb229af6196a78397bc67178f9d901bf1e04efa3b6a9365ab6ba850cd353bd32b5864bf50d8b2f1314ec49109400679453f37a16867b11e5c5580"
  ); // Your secret API key

module.exports = async function (req, res) {
  const { email, secret, otp } = req.body;

  try {
    // Hardcoded user ID for testing
    const hardcodedUserId = "67786b186341deed4b7c";

    // Create Email Token
    const createEmailToken = async (email) => {
      const token = await account.createEmailToken(hardcodedUserId, email);
      return token;
    };

    // Verify Email Token
    const verifyEmailToken = async (userId, otp) => {
      await account.updateEmailVerification(userId, otp);
    };

    // Delete All Sessions
    const deleteAllSessions = async (userId) => {
      const sessions = await account.listSessions(userId);
      for (const session of sessions.sessions) {
        await account.deleteSession(userId, session.$id);
      }
    };

    // Create Session
    const createSession = async (userId, secret) => {
      await deleteAllSessions(userId); // Delete existing sessions
      const session = await account.createSession(userId, secret);
      return session;
    };

    // Example usage based on request
    if (req.path === "/createEmailToken") {
      const token = await createEmailToken(email);
      res.json({ userId: hardcodedUserId, token });
    } else if (req.path === "/verifyEmailToken") {
      await verifyEmailToken(hardcodedUserId, otp);
      res.json({ message: "Email verified successfully" });
    } else if (req.path === "/createSession") {
      const session = await createSession(hardcodedUserId, secret);
      res.json({ userId: hardcodedUserId, session });
    } else {
      res.status(400).json({ error: "Invalid request" });
    }
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: error.message });
  }
};
