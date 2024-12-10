const {
  Clarinet,
  Tx,
  Chain,
  Account,
  Contract,
  types
} = require('clarinet');

/**
 * Prediction Market Interaction Utilities
 * Provides methods for interacting with the prediction market contract
 */
class PredictionMarketInteraction {
  /**
   * Create a new prediction market
   * @param {Chain} chain - Clarinet chain instance
   * @param {Account} deployer - Account creating the market
   * @param {string} description - Market description
   * @param {string[]} outcomes - Possible market outcomes
   * @returns {Object} Transaction and market details
   */
  static createMarket(chain, deployer, description, outcomes) {
    const tx = chain.mineTransaction(
      Tx.contractCall(
        'prediction-market', 
        'create-market', 
        [
          types.utf8(description),
          types.list(outcomes.map(types.utf8))
        ],
        deployer.address
      )
    );

    return {
      tx,
      marketId: tx.result.expectOk(),
      description
    };
  }

  /**
   * Place a bet on a market
   * @param {Chain} chain - Clarinet chain instance
   * @param {Account} bettor - Account placing the bet
   * @param {number} marketId - Market identifier
   * @param {number} outcomeIndex - Index of the chosen outcome
   * @param {number} betAmount - Amount to bet
   * @returns {Object} Transaction result
   */
  static placeBet(chain, bettor, marketId, outcomeIndex, betAmount) {
    const tx = chain.mineTransaction(
      Tx.contractCall(
        'prediction-market',
        'place-bet',
        [
          types.uint(marketId),
          types.uint(outcomeIndex),
          types.uint(betAmount)
        ],
        bettor.address
      )
    );

    return {
      tx,
      success: tx.result.expectOk()
    };
  }

  /**
   * Resolve a market with a winning outcome
   * @param {Chain} chain - Clarinet chain instance
   * @param {Account} resolver - Account resolving the market
   * @param {number} marketId - Market identifier
   * @param {number} winningOutcome - Index of the winning outcome
   * @returns {Object} Transaction result
   */
  static resolveMarket(chain, resolver, marketId, winningOutcome) {
    const tx = chain.mineTransaction(
      Tx.contractCall(
        'prediction-market',
        'resolve-market',
        [
          types.uint(marketId),
          types.uint(winningOutcome)
        ],
        resolver.address
      )
    );

    return {
      tx,
      success: tx.result.expectOk()
    };
  }

  /**
   * Retrieve market details
   * @param {Chain} chain - Clarinet chain instance
   * @param {number} marketId - Market identifier
   * @returns {Object} Market details
   */
  static getMarketDetails(chain, marketId) {
    const receipt = chain.callReadOnlyFn(
      'prediction-market',
      'get-market-details',
      [types.uint(marketId)],
      Clarinet.defaultSenderAddress
    );

    return receipt.result;
  }

  /**
   * Simulate a full prediction market lifecycle
   * @param {Chain} chain - Clarinet chain instance
   * @param {Account[]} accounts - Available test accounts
   */
  static simulateMarketLifecycle(chain, accounts) {
    const [deployer, bettor1, bettor2, resolver] = accounts;

    // Create market
    const marketCreation = this.createMarket(
      chain, 
      deployer, 
      'Will Bitcoin reach $100k in 2024?', 
      ['Yes', 'No']
    );

    // Place bets
    this.placeBet(chain, bettor1, marketCreation.marketId, 0, 100);
    this.placeBet(chain, bettor2, marketCreation.marketId, 1, 50);

    // Resolve market
    this.resolveMarket(chain, resolver, marketCreation.marketId, 0);

    // Retrieve and log market details
    const marketDetails = this.getMarketDetails(chain, marketCreation.marketId);
    console.log('Market Details:', marketDetails);
  }
}

// Export the interaction utilities
module.exports = PredictionMarketInteraction;

// Example usage demonstration
function runInteractionDemo() {
  Clarinet.test({
    name: "Prediction Market Interaction Demonstration",
    async fn(chain, accounts) {
      PredictionMarketInteraction.simulateMarketLifecycle(chain, accounts);
    }
  });
}

// Uncomment to run demo
// runInteractionDemo();
