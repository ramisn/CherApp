class TileOrganizer {
  MAX_TILES = 5;

  tiles = {};

  counterTile = {};

  constructor() {
    for (let i = 1; i <= this.MAX_TILES; i += 1) this.counterTile[i] = null;
  }

  acquireTileIndex(tileId, externalUserId) {
    if (!externalUserId) return null;
    if (this.tiles[externalUserId]) return this.tiles[externalUserId];

    const tilePosition = this.findOpenTile();
    if (tilePosition) {
      this.tiles[externalUserId] = {
        externalTileId: tilePosition,
        tileId,
      };
      this.counterTile[tilePosition] = externalUserId;

      return this.tiles[externalUserId];
    }

    return null;
  }

  releaseTileIndex(tileId) {
    const externalUserId = Object.keys(this.tiles).find((k) => this.tiles[k].tileId === tileId);
    const counterTileIdKey = Object.keys(this.counterTile).find(
      (k) => this.counterTile[k] === externalUserId,
    );
    const tile = this.tiles[externalUserId];

    this.counterTile[counterTileIdKey] = null;

    return tile;
  }

  findOpenTile() {
    // eslint-disable-next-line no-restricted-syntax
    for (const [externalTileId, userId] of Object.entries(this.counterTile)) {
      if (!userId) return externalTileId;
    }

    return null;
  }
}

export default TileOrganizer;
