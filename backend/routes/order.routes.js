import express from 'express';
import { createOrder, getOrderHistory } from '../controllers/order.controller.js';
import { authenticateToken } from '../middleware/auth.middleware.js';

const router = express.Router();

router.post('/', authenticateToken, createOrder);
router.get('/history', authenticateToken, getOrderHistory);

export default router; 