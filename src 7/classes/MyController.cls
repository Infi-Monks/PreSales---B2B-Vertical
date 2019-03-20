public class MyController {

    Integer count = 0;

    public PageReference incrementCounter() {
            count++;
            return null;
    }

    public PageReference decrementCounter() {
            count--;
            return null;
    }

    public Integer getCount() {
        return count;
    }
}