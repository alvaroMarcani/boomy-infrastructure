-- Seed game modes
INSERT INTO "GameModes" (Id, Name, Description, Number, ImageUrl, MinLevel, MaxPlayers, RewardMoney, RewardExp, Type, IsActive, CreatedAt, UpdatedAt) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Solo', 'Solo adventure mode', 1, '/assets/modes/solo.jpg', 1, 1, 1000, 100, 'Solo', true, NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'Tag', 'Tag team battle mode', 2, '/assets/modes/tag.jpg', 5, 2, 2500, 250, 'Tag', true, NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440003', 'Score', 'Score-based competitive mode', 3, '/assets/modes/score.jpg', 10, 4, 5000, 500, 'Score', true, NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440004', 'Jewel', 'Jewel hunting and collection mode', 4, '/assets/modes/jewel.jpg', 15, 4, 7500, 750, 'Jewel', true, NOW(), NOW());
