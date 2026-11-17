new Phaser.Game({
  type: Phaser.AUTO,
  width: 800,
  height: 600,
  parent: 'game',
  scene: {
    create() {
      this.add.text(400, 300, 'Hello World', { fontSize: '48px', color: '#ffffff' }).setOrigin(0.5);
    }
  }
});
