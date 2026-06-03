import express from 'express';
import { 
  addToCart, 
  getCart, 
  removeFromCart, 
  updateCartQuantity 
} from '../controllers/cart.controller.js';
import { authenticateToken } from '../middleware/auth.middleware.js';

const router = express.Router();

router.post('/add', authenticateToken, addToCart);
router.get('/', authenticateToken, getCart);
router.delete('/:productId', authenticateToken, removeFromCart);
router.put('/:productId', authenticateToken, updateCartQuantity);

export default router; 