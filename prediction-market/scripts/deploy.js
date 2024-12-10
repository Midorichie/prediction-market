const { Client, Provider, ProviderRegistry, Result } = require('@stacks/transactions');

async function deployPredictionMarket() {
  // Setup Stacks provider
  const provider = await ProviderRegistry.createProvider();
  const client = new Client(provider);

  try {
    // Deploy the prediction market contract
    const deployment = await client.deployContract({
      contractName: 'prediction-market',
      claritySource: fs.readFileSync('./contracts/prediction-market.clar', 'utf8'),
      network: 'testnet' // or mainnet
    });

    console.log('Contract deployed successfully:', deployment.txId);

    // Example interaction: Create a market
    const createMarketTx = await client.callContract({
      contractAddress: deployment.contractAddress,
      contractName: 'prediction-market',
      functionName: 'create-market',
      functionArgs: [
        { type: 'utf8', value: 'Will Bitcoin reach $100k in 2024?' },
        { type: 'list', value: ['Yes', 'No'] }
      ]
    });

    console.log('Market created:', createMarketTx);
  } catch (error) {
    console.error('Deployment error:', error);
  } finally {
    provider.close();
  }
}

// Run deployment
deployPredictionMarket();
